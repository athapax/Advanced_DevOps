resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal : {
          "AWS" : aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        },
        Action = "s3:GetObject",
        Resource : [
          "${aws_s3_bucket.website_bucket.arn}",
        "${aws_s3_bucket.website_bucket.arn}/*"]
      }
    ]
  })
}
