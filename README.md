# aws-eks-compliance-checker
AWS EKS Compliance Checker is a lightweight shell-script tool to scan EKS clusters for basic CIS-aligned security controls. 
It evaluates Control Plane Public Access, Control Plane Logging, and Secrets Encryption using AWS CLI commands and outputs a CSV report with compliance status, severity, actual vs expected values, and remediation recommendations.

Designed for:
- Cloud security auditing
- DevSecOps workflows
- Compliance reporting
- Easy integration into CI/CD pipelines

The tool is fully extensible and can be expanded to additional controls or frameworks like ISO 27001, NIST, or Trend Micro.
