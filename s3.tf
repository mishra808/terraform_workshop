resource "aws_s3_bucket" "web_test_bucket" {
  bucket = "test-webapp-bkt-example"
}

resource "aws_s3_bucket_cors_configuration" "web_test_bucket" {
  bucket = aws_s3_bucket.web_test_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_public_access_block" "public_accessebility" {
  bucket = aws_s3_bucket.web_test_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.web_test_bucket.id
  policy = data.aws_iam_policy_document.policy_one.json
}

data "aws_iam_policy_document" "policy_one" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.web_test_bucket.arn,
      "${aws_s3_bucket.web_test_bucket.arn}/*",
    ]
  }
}
