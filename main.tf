provider "azurerm" {
  version = "=2.3.0"
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "tstatesa"
    container_name       = "tstate"
    resource_group_name  = "tstate-rg"
    key                  = "tagging.policy.tfstate"
    access_key           = "lL98ruzb12F+-Add-Your-Key-=="
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-zabbix"
  location = "eastus"
}


resource "azurerm_policy_definition" "add_monitor_tier_tag-test-dev-Qa" {
  name         = "add_monitor_tier_tag-test-dev-Qa"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Add monitor_tier tag to VM resources - Test, Dev and QA"

  policy_rule = <<POLICY_RULE
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
                "contains": "test"
              },
              {
                "field": "name",
                "contains": "dev"
              },
              {
                "field": "name",
                "contains": "qa"
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
          "conflictEffect": "audit",
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
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag 'monitor_tier'"
        }
      },
      "tagValue": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Value",
          "description": "Value of the tag 'P3'"
        }
      }
    }
PARAMETERS
  metadata   = <<METADATA
    {
      "category": "Tags"
    }
METADATA

}

resource "azurerm_policy_definition" "add_monitor_tier_tag-prod-prd" {
  name         = "add_monitor_tier_tag-prod-prd"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Add monitor_tier tag to VM resources - Prod and Prd"

  policy_rule = <<POLICY_RULE
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
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag as 'monitor_tier'"
        }
      },
      "tagValue": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Value",
          "description": "Value of the tag 'P2'"
        }
      }
    }
PARAMETERS
  metadata   = <<METADATA
    {
      "category": "Tags"
    }
METADATA

}

resource "azurerm_policy_definition" "add_monitor_tier_tag-unclassified-VMs" {
  name         = "add_monitor_tier_tag-unclassified-VMs"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Add monitor_tier tag  to unclassified VM names"

  policy_rule = <<POLICY_RULE
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
            "not": {
              "field": "name",
              "contains": "test"
            }
          },
          {
            "not": {
              "field": "name",
              "contains": "dev"
            }
          },
          {
            "not": {
              "field": "name",
              "contains": "qa"
            }
          },
          {
            "not": {
              "field": "name",
              "contains": "prod"
            }
          },
          {
            "not": {
              "field": "name",
              "contains": "prd"
            }
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
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag 'monitor_tier'"
        }
      },
      "tagValue": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Value",
          "description": "Value of the tag 'P2'"
        }
      }
    }
PARAMETERS
  metadata   = <<METADATA
    {
      "category": "Tags"
    }
METADATA
}


resource "azurerm_policy_definition" "add_maintenance_epoch-epoch_tag" {
  name         = "add_maintenance_epoch-epoch_tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Add maintenance_epoch-epoch tag on VM resources"

  policy_rule = <<POLICY_RULE
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
          }
        ]
      },
      "then": {
        "effect": "modify",
        "details": {
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
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
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag, such as 'environment'"
        }
      },
      "tagValue": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Value",
          "description": "Value of the tag, such as 'production'"
        }
      }
    }
PARAMETERS
  metadata   = <<METADATA
    {
      "category": "Tags"
    }
METADATA
}

resource "azurerm_policy_definition" "require_monitor_tier-tag" {
  name         = "require_monitor_tier-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require valid value [P1-P4] for monitor_tier tag on VM resources"

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
          },
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": "true"
          },
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "notIn": "[parameters('tagValue')]"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag 'monitor_tier'"
        }
      },
      "tagValue": {
        "type": "Array",
        "metadata": {
          "displayName": "Tag Value",
          "description": "Tag allowed values P1, P2, P3, P4"
        },
        "allowedValues": [
          "P1",
          "P2",
          "P3",
          "P4"
        ]
      }
    }
PARAMETERS
  metadata   = <<METADATA
    {
      "category": "Tags"
    }
METADATA
}

resource "azurerm_policy_definition" "require_maintenance_epoch-epoch-tag" {
  name         = "require_maintenance_epoch-epoch-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require valid epoch values for maintenance_epoch-epoch tag on VM resources"

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
          },
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "notMatch": "##########-##########"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag, such as maintenance_epoch-epoch"
        }
      }
    }
PARAMETERS
  metadata   = <<METADATA
    {
      "category": "Tags"
    }
METADATA
}

resource "azurerm_policy_set_definition" "zbxTagGovernPolicySet" {
  description  = "Zabbix monitoring tool requires monitor_tier and maintenance_epoch-epoch tags. Created By: Terraform"
  display_name = "Tag governance for Zabbix monitoring tool"
  metadata = jsonencode(
    {
      category = "Tags"
      parameterScopes = {
        tagValue = azurerm_resource_group.rg.id
      }
    }
  )
  name = "zbxTagGovernPolicySet"
  policy_definitions = jsonencode(
    [
      {
        parameters = {
          tagName = {
            value = "monitor_tier"
          }
          tagValue = {
            value = [
              "P1",
              "P2",
              "P3",
              "P4",
            ]
          }
        }
        policyDefinitionId = azurerm_policy_definition.require_monitor_tier-tag.id
      },
      {
        parameters = {
          tagName = {
            value = "monitor_tier"
          }
          tagValue = {
            value = "P2"
          }
        }
        policyDefinitionId = azurerm_policy_definition.add_monitor_tier_tag-prod-prd.id
      },
      {
        parameters = {
          tagName = {
            value = "monitor_tier"
          }
          tagValue = {
            value = "P3"
          }
        }
        policyDefinitionId = azurerm_policy_definition.add_monitor_tier_tag-test-dev-Qa.id
      },
      {
        parameters = {
          tagName = {
            value = "monitor_tier"
          }
          tagValue = {
            value = "P2"
          }
        }
        policyDefinitionId = azurerm_policy_definition.add_monitor_tier_tag-unclassified-VMs.id
      },
      {
        parameters = {
          tagName = {
            value = "maintenance_epoch-epoch"
          }
        }
        policyDefinitionId = azurerm_policy_definition.require_maintenance_epoch-epoch-tag.id
      },
      {
        parameters = {
          tagName = {
            value = "maintenance_epoch-epoch"
          }
          tagValue = {
            value = "0000000000-0000000000"
          }
        }
        policyDefinitionId = azurerm_policy_definition.add_maintenance_epoch-epoch_tag.id
      },
    ]
  )
  policy_type = "Custom"
}

resource "azurerm_policy_assignment" "Tag-governance-for-Zabbix" {
  name  = "Tag-governance-for-Zabbix"
  scope = azurerm_resource_group.rg.id
  #   scope                = "/subscriptions/d0-Add-Your-Subscription-ID-***b/resourceGroups/rg-zabbix"
  policy_definition_id = azurerm_policy_set_definition.zbxTagGovernPolicySet.id
  #   policy_definition_id = "/subscriptions/d0-Add-Your-Subscription-ID-***b/providers/Microsoft.Authorization/policySetDefinitions/c20d0a00-************-eb8e46321aba"
  description  = "Tag governance for Zabbix monitoring tool - Created By: Terraform"
  display_name = "Tag governance for Zabbix monitoring tool"
  location     = "eastus"
  identity { type = "SystemAssigned" }

  #   metadata = <<METADATA
  #     {
  #     "category": "Tags"
  #     }
  # METADATA
}

