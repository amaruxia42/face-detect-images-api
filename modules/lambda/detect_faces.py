
import boto3
import json

rekognition = boto3.client('rekognition')

def lambda_handler(event, context):
    try:
        if 'body' not in event:
            return {"statusCode": 400, "body": json.dumps({"error": "Missing body"})}

        body = json.loads(event['body'])
        image_key = body.get('image')
        bucket_name = body.get('bucket', 'your-default-bucket-name')  # Allow bucket override or use default

        if not image_key:
            return {"statusCode": 400, "body": json.dumps({"error": "Missing 'image'"})}

        # Use Rekognition with S3 object directly
        response = rekognition.detect_faces(
            Image={
                'S3Object': {
                    'Bucket': bucket_name,
                    'Name': image_key
                }
            },
            Attributes=['ALL']
        )

        faces = []
        for face in response["FaceDetails"]:
            faces.append({
                "confidence": face["Confidence"],
                "bounding_box": face["BoundingBox"],
                "age_range": face["AgeRange"],
                "gender": face["Gender"]
            })

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"face_count": len(faces), "faces": faces})
        }

    except rekognition.exceptions.InvalidS3ObjectException:
        return {
            "statusCode": 404,
            "body": json.dumps({"error": "Image not found in S3 bucket"})
        }
    except rekognition.exceptions.InvalidImageFormatException:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid image format"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }

def validate_input(body):
    if not isinstance(body.get('image'), str):
        raise ValueError("Image must be a string")

    if not body.get('image').strip():
        raise ValueError("Image filename cannot be empty")

    # Sanitize filename
    image_key = body['image'].strip()
    if not image_key.lower().endswith(('.jpg', '.jpeg', '.png', '.gif')):
        raise ValueError("Invalid image format")

    return image_key