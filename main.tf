variable "first_name" {
  description = "first name"
}

variable "last_name" {
  description = "last name"
}

variable "email" {
  description = "email"
}

variable "phone" {
  description = "phone"
}

variable "card_number" {
  description = "credit card number"
}

variable "card_cvv" {
  description = "cvv"
}

variable "card_expiration_date" {
  description = "expiration date"
}

variable "card_zip_code" {
  description = "zip code"
}

variable "store_street" {
  description = "store street"
}

variable "store_city" {
  description = "store city"
}

variable "store_state" {
  description = "store state"
}

variable "store_zip_code" {
  description = "store zip code"
}

provider "dominos" {
  first_name    = "Roger"
  last_name     = "Berlind"
  email_address = "roger@hashicorp.com"
  phone_number  = "15555555555"

  credit_card {
    number = 1234567891011123
    cvv    = 131
    date   = "09/22"
    zip    = 18192
  }
}

data "dominos_address" "addr" {
  street = "464 3rd Avenue"
  city   = "New York"
  state  = "NY"
  zip    = "10016"
}

data "dominos_store" "store" {
  address_url_object = "${data.dominos_address.addr.url_object}"
}

data "dominos_menu_item" "item" {
  store_id     = "${data.dominos_store.store.store_id}"
  query_string = ["philly", "medium"]
}

resource "dominos_order" "order" {
  address_api_object = "${data.dominos_address.addr.api_object}"
  item_codes         = ["${data.dominos_menu_item.item.matches.0.code}"]
  store_id           = "${data.dominos_store.store.store_id}"
}
