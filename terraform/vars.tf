variable "AWS_REGION" {
    default = "us-east-1"
}
variable "AWS_ACCOUNT_ID"{
    default = "546525900473"
}
variable "namespace" {
    type = string
    default = "hz"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "tags" {
    type = map

    default = {
    Terraform   = "true"
    Environment = "dev"
    Namespace   = "hz"
    }
}