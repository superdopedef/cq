variable "random_pet_length" {
    default = 1
    type = number
}

variable "random_pet_separator" {
    default = "-"
    type = string
}

variable "debian_search" {
    default = "debian-10*"
    type = string
}
