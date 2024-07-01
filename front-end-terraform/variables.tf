variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-west-2"  # Change to eu-west-2
}

variable "bucket_name" {
  description = "The name of the existing S3 bucket"
  type        = string
  default     = "video-player-mesgna-2024" 
}

variable "index_document_suffix" {
  description = "The suffix for the index document"
  type        = string
  default     = "index.html"
}

variable "error_document_key" {
  description = "The key for the error document"
  type        = string
  default     = "error.html"
}
