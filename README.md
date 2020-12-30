# VM Tag Governance using Custom Azure Policy via Terraform

Recently had a requirement from a client that all of their Azure VMs must be tagged with a specific set of tags to be used by Monitoring tool to cut a service ticket when a VM is down based on production or non-production classification, and also use epoch maintenance time range tag to avoid a ticket when VM is down intemtionally for maintenance. 

Custom policies provisioned with Terraform were used along with initiative definition to govern 2 required tags for monitoring.  Policies make sure that all VM resources have monitier_tier and maintenance_epoch-epoch tags with valid values.  For monitier_tier tag, values are auto generated based on the keywords [prod, prd, test, QA, dev] in the VM’s name. If no keyword is present in VM name then it will be considered the production.

```json
{
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
          },
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": "false"
          },
          {
            "anyof": [
              {
                "field": "name",
                "contains": "prod"
              },
              {
                "field": "name",
                "contains": "prd"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "modify",
        "details": {
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f"
          ],
          "operations": [
            {
              "operation": "add",
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "value": "[parameters('tagValue')]"
            }
          ]
        }
      }
    } 
```
 
Assign the policy initiative to Azure subscription.  Also, create one-time remediation tasks for policy #2 to #6 from the list below to add tags to existing VM resources. 

In the event of conflict in VMs name e.g. ProdDevOpS which has both Prod and Dev keyword, production policy was made win by lowering the precedence of Dev/QA/Test policy by setting conflictEffect value to audit.

```json
"effect": "modify",
        "details": {
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f"
          ],
          "conflictEffect": "audit",
 ```
 
Policies
 
1.	Require valid value [P1-P4] for monitor_tier tag on VM resources
2.	Require valid epoch values for maintenance_epoch-epoch tag on VM resources
3.	Add maintenance_epoch-epoch tag on VM resources
4.	Add monitor_tier tag to VM resources - Test, Dev and QA
5.	Add monitor_tier tag to VM resources - Prod and Prd
6.	Add monitoring_tier tag  to unclassified VM names
 
PolicySet/Initiative
 
1.	Tag governance for monitoring tool
