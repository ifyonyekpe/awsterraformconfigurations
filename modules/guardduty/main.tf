resource "aws_guardduty_detector" "demo-guardduty" {
  enable = var.enable_guardduty
  
  datasources {
    s3_logs {
      enable = var.enable_guardduty_s3_logs
    }
    kubernetes {
      audit_logs {
        enable = var.enable_guardduty_kubernetes_audit_logs
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_guardduty_ebs_volumes
        }
      }
    }
  }
}