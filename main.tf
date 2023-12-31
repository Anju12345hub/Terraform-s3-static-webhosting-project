resource "aws_s3_bucket" "bucketweb" {
  bucket = var.web-bucketname

  tags = {
    Name  =var.web-bucketname
  }
}
#To ensure the ownership of the bucket
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucketweb.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
#To make the bucket public
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucketweb.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
#give ACL permission
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.bucketweb.id
  acl    = "public-read"
}
#For adding objects
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.bucketweb.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.bucketweb.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.bucketweb.id
  key    = "profile1.jpg"
  source = "profile1.jpg"
  acl = "public-read"
  
}
#s3 bucket wesite configuration
resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.bucketweb.id
    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
    depends_on = [ aws_s3_bucket_acl.example ]
}
