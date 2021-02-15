#Variables----------------------------------------------------------------------
variable "allowed_ports_sg" {
  description = "List of ports to open for SG"
  type        = list(any)
  default     = ["80", "443", "8080"]
}
variable "env" {
  default = "prod"
}
