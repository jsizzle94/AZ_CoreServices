variable "rglocation" {
  type = string
  default = "UK South"
}
variable "rgname" {
  type = string
}
variable "application" {
  type = string
}
variable "vnet_addressspace" {
  type = list()
}
variable "subnets" {
  type = list()
}
