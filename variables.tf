variable "rglocation" {
  type    = string
  default = "UK South"
}
variable "application" {
  type = string
}
variable "vnet_addressspace" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "gwsubnet" {
  type = list(string)
}