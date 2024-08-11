resource "aws_s3_bucket" "my-bucket" {
  bucket = "react-app-bucket-xyz"
}

# resource "aws_s3_object" "my-webapp" {
#   bucket = aws_s3_bucket.my-bucket.bucket
#   source = "./index.html"
#   key = "index.html"
#   content_type = "text/html"
# }


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.my-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.my-bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.my-bucket.id

  index_document {
    suffix = "index.html"
  }
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket.my-bucket.website_endpoint
}