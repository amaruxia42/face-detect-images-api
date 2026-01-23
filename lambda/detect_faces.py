import boto3
import json
import logging
from typing import Any


logger = logging.getLogger()
logger.setLevel(logging.INFO)

rekognition = boto3.client('rekognition')


def api_gw_responses(status_code: int, body: dict[str, Any]) -> dict[str, Any]:
    """Helper to format API Gateway responses"""
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body)
    }


def extract_face_data(face_details: list[dict]) -> list[dict]:
    """
    Parses raw Rekognition data into a clean simplified format.
    """
    return [
        {
            "confidence": face.get("Confidence"),
            "bounding_box": face.get("BoundingBox"),
            "age_range": face.get("AgeRange"),
            "gender": face.get("Gender")
        }
        for face in face_details
    ]


def lambda_handler(event: Any, context) -> dict[str, Any]:
    """
    Detects faces in an image stored in S3 using Amazon Rekognition.

    Expected Input (event):
        {
            "body": "{\"image\": \"path/to/image.jpg\", \"bucket\": \"optional-bucket-name\"}"
        }

    Returns:
        dict: A standard API Gateway response containing status code, headers, and
              a JSON body with face count and specific face details (confidence,
              bounding box, age, and gender).
    """
    try:
        if 'body' not in event:
            return api_gw_responses(400,{"error": "Missing request body"})

        body = json.loads(event['body'])
        image_key = validate_input(body)
        bucket_name = body.get('bucket', 'face-images-bucket')  # Allow bucket override or use default

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

        faces = extract_face_data(response.get('FaceDetails', []))

        return api_gw_responses(200, {
            "face_count": len(faces),
            "faces": faces
        })

    except ValueError as ve:
        return api_gw_responses(400, {
            "error": str(ve)
        })
    except rekognition.exceptions.InvalidS3ObjectException:
        return api_gw_responses(404, {
            "error": "Image not found in S3 bucket"
        })
    except rekognition.exceptions.InvalidImageFormatException:
        return api_gw_responses(400, {
            "error": "Invalid image format"
        })
    except Exception as e:
        logger.error(f"Unexpected error {e}")
        return api_gw_responses(500,{
            "error": "Internal server error"
        })


def validate_input(body: dict) -> str:
    """
    Validates that the 'image' key is present, is a non-empty string
    and has the supported file extension.
    Returns the sanitised (stripped) image_key string.
    """
    image_key = body.get('image')

    if not isinstance(image_key, str) or not image_key.strip():
        raise ValueError("Image key must be a non-empty string")

    image_key = image_key.strip()
    valid_file_extensions = ('.jpg', '.jpeg', '.png')

    if not image_key.lower().endswith(valid_file_extensions):
        raise ValueError(f"Unsupported image file extension Use valid: {valid_file_extensions}")

    return image_key




