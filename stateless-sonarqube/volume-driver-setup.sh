#!/bin/bash
docker plugin install --alias cloudstor:azure2 \
  --grant-all-permissions docker4x/cloudstor:17.06.1-ce-azure1  \
  CLOUD_PLATFORM=AZURE \
  AZURE_STORAGE_ACCOUNT_KEY="kZaxd8C98Bhjf3HO3YyDJpmBCrP/M5HbO4m/lg0oMqGnYXGBWqtKSNs7O7Rv8kztSgPT05hEbDoMxezFofyUXQ==" \
  AZURE_STORAGE_ACCOUNT="azurefiledriverac1" \
  DEBUG=1