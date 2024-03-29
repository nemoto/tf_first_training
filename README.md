# Terraform Module sample

## Course Description
### Target person
- Must have IAM/role with network/EC2 related permissions in AWS.
- Must have a level of knowledge of AWS basis (to create VPC, Subnet, Gateway, EC2, etc. in AWS console).

### Course Objectives
- Know basic usage of terraform

### Required environment
- asdf
    - The Multiple Runtime Version Manager. In this case, used for terraform, python.
        ```shell
        $ asdf current
        python          3.11.8          /{somewhere}/.tool-versions
        terraform       1.7.5           /{somewhere}/.tool-versions

        ````
- terraform
    - terraform itself
        - required_version = ">= 1.7.0"
        - Note: use asdf for version management.
    - terraform provider plugins
        - aws
            - source  = "hashicorp/aws"
            - version = ">= 5.20.0"
    ```shell
    $ terraform providers -version
    Terraform v1.7.5
    on darwin_arm64
    + provider registry.terraform.io/hashicorp/aws v5.40.0
    ```
- tflint
    - terraform files linter
- terraform-docs
    - module documenter.
        - useded in doc.py (module documenter sample)

## Souce Description

### Target System
- Points to note
    - This code is written in such a way that it can be learned and actually modified during the workshop (the code is committed as it should be modified).