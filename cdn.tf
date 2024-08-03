resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.website_bucket.bucket}.s3.amazonaws.com"
    origin_id   = "S3-${aws_s3_bucket.website_bucket.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static website hosting with S3 and CloudFront"
  default_root_object = "index.html"

  aliases = [
    "${var.subdomain_name}.${var.domain_name}"
  ]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = "S3-${aws_s3_bucket.website_bucket.bucket}"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.policy.id # Attach the response headers policy
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  #  restrictions {
  #    geo_restriction {
  #      restriction_type = "whitelist"
  #      locations        = ["US", "GB"]
  #    }
  #  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  web_acl_id = var.enable_waf ? aws_wafv2_web_acl.waf.arn : null
  depends_on = [aws_wafv2_web_acl.waf]
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin Access Identity for S3 website bucket"
}
