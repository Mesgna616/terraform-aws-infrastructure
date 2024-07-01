# Define required providers and their versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"  # Updated AWS provider version
    }
  }
}

# AWS provider configuration
provider "aws" {
  region = var.region  # Use the region specified in variables
}

# S3 static website bucket resource
resource "aws_s3_bucket" "my_static_page_bucket" {
  bucket = var.bucket_name  # Use the bucket name specified in variables

  # Tags for the S3 bucket
  tags = {
    Name = "Videoplayerdescription"
    # Additional tags can be added here
  }
}

# Configure S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "my_static_page_website" {
  bucket = aws_s3_bucket.my_static_page_bucket.id  # Reference the created bucket

  # Index document configuration
  index_document {
    suffix = var.index_document_suffix  # Use the index document suffix specified in variables
  }

  # Error document configuration
  error_document {
    key = var.error_document_key  # Use the error document key specified in variables
  }
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "my_static_page_ownership_controls" {
  bucket = aws_s3_bucket.my_static_page_bucket.id

  # Specify object ownership preference
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access block settings for the bucket
resource "aws_s3_bucket_public_access_block" "my_static_page_public_access_block" {
  bucket                  = aws_s3_bucket.my_static_page_bucket.id
  block_public_acls       = false  # Allow public ACLs
  block_public_policy     = false  # Allow public bucket policies
  ignore_public_acls      = false  # Do not ignore public ACLs
  restrict_public_buckets = false  # Do not restrict public buckets
}

# Configure ACL access for the bucket
resource "aws_s3_bucket_acl" "my_static_page_acl" {
  bucket = aws_s3_bucket.my_static_page_bucket.id
  acl    = "public-read"  # Set ACL to allow public read access
}

# Define S3 bucket policy for allowing public access
resource "aws_s3_bucket_policy" "my_static_page_policy" {
  bucket = aws_s3_bucket.my_static_page_bucket.id

  # JSON policy document allowing public read access to objects
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.my_static_page_bucket.arn}/*"
      }
    ]
  })
}

# Output the website URL of the static S3 bucket
output "website_url" {
  value = "http://${aws_s3_bucket.my_static_page_bucket.bucket}.s3-website.${var.region}.amazonaws.com"
}
