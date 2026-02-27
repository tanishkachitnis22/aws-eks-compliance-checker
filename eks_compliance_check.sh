#!/bin/bash
# AWS EKS Compliance Checker (Shell Script)
# Usage: ./eks_compliance_check.sh <cluster_name> <region>
# Requirements: aws CLI installed and configured, jq installed

CLUSTER_NAME=$1
REGION=$2

if [ -z "$CLUSTER_NAME" ] || [ -z "$REGION" ]; then
  echo "Usage: $0 <cluster_name> <region>"
  exit 1
fi

REPORT_FILE="eks_compliance_report_$(date +%F_%H%M%S).csv"

echo "Control ID,Control Name,Severity,Expected,Actual,Compliant,Recommendation" > $REPORT_FILE
echo "Scanning EKS cluster: $CLUSTER_NAME ($REGION)..."
echo ""

# --- Control 1: Public access ---
CONTROL_ID="EKS-CP-001"
CONTROL_NAME="Control Plane Public Access"
SEVERITY="High"
EXPECTED="false"
ACTUAL=$(aws eks describe-cluster --name "$CLUSTER_NAME" --region "$REGION" \
  --query "cluster.resourcesVpcConfig.endpointPublicAccess" --output text)
COMPLIANT="❌"
[ "$ACTUAL" == "$EXPECTED" ] && COMPLIANT="✅"
RECOMMENDATION="Restrict endpoint public access to private or whitelisted CIDRs"
echo "$CONTROL_ID,$CONTROL_NAME,$SEVERITY,$EXPECTED,$ACTUAL,$COMPLIANT,$RECOMMENDATION" >> $REPORT_FILE

# --- Control 2: Control plane logging ---
CONTROL_ID="EKS-CP-002"
CONTROL_NAME="Control Plane Logging"
SEVERITY="Medium"
EXPECTED="api,audit,authenticator,controllerManager,scheduler"
LOGGING=$(aws eks describe-cluster --name "$CLUSTER_NAME" --region "$REGION" \
  --query "cluster.logging.clusterLogging[].types[]" --output text)
COMPLIANT="❌"
[[ "$LOGGING" == *"api"* && "$LOGGING" == *"audit"* && "$LOGGING" == *"authenticator"* && "$LOGGING" == *"controllerManager"* && "$LOGGING" == *"scheduler"* ]] && COMPLIANT="✅"
RECOMMENDATION="Enable all control plane logs using aws eks update-cluster-config --logging ..."
echo "$CONTROL_ID,$CONTROL_NAME,$SEVERITY,$EXPECTED,$LOGGING,$COMPLIANT,$RECOMMENDATION" >> $REPORT_FILE

# --- Control 3: Secrets Encryption ---
CONTROL_ID="EKS-CP-003"
CONTROL_NAME="Secrets Encryption"
SEVERITY="High"
EXPECTED="secrets"
ENCRYPTION=$(aws eks describe-cluster --name "$CLUSTER_NAME" --region "$REGION" \
  --query "cluster.encryptionConfig[].resources[]" --output text)
COMPLIANT="❌"
[[ "$ENCRYPTION" == *"secrets"* ]] && COMPLIANT="✅"
RECOMMENDATION="Enable envelope encryption with KMS for secrets at rest"
echo "$CONTROL_ID,$CONTROL_NAME,$SEVERITY,$EXPECTED,$ENCRYPTION,$COMPLIANT,$RECOMMENDATION" >> $REPORT_FILE

echo ""
echo "✅ Compliance report generated: $REPORT_FILE"
echo "You can open this CSV in Excel or Google Sheets." i had this in my readm.file change it a  better part. 
