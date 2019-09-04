terraform {
  required_version = ">= 0.12.0"
}

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

variable "pizza_attributes" {
  description = "attributes of the pizzas to order"
  type        = list(list(string))
}

variable "drink_attributes" {
  description = "attributes of the drinks to order"
  type        = list(list(string))
}

provider "dominos" {
  first_name    = var.first_name
  last_name     = var.last_name
  email_address = var.email
  phone_number  = var.phone

  credit_card {
    number = var.card_number
    cvv    = var.card_cvv
    date   = var.card_expiration_date
    zip    = var.card_zip_code
  }
}

data "dominos_address" "addr" {
  street = var.store_street
  city   = var.store_city
  state  = var.store_state
  zip    = var.store_zip_code
}

data "dominos_store" "store" {
  address_url_object = data.dominos_address.addr.url_object
}

data "dominos_menu_item" "pizzas" {
  count        = length(var.pizza_attributes)
  store_id     = data.dominos_store.store.store_id
  query_string = var.pizza_attributes[count.index]
}

data "dominos_menu_item" "drinks" {
  count        = length(var.drink_attributes)
  store_id     = data.dominos_store.store.store_id
  query_string = var.drink_attributes[count.index]
}

resource "dominos_order" "order" {
  address_api_object = data.dominos_address.addr.api_object
  item_codes         = [data.dominos_menu_item.pizzas[*].matches[0].code, data.dominos_menu_item.drinks[*].matches[0].code]
  store_id           = data.dominos_store.store.store_id
}

# Uncomment this when commenting out the dominos_order resource
# so that you can do an apply and see the outputs
/*resource "random_id" "random" {
  keepers  = {
    uuid = "${uuid()}"
  }
  byte_length = 32
}*/

output "pizzas" {
  value = [
    for pizza in data.dominos_menu_item.pizzas:
      {
        name = pizza.matches[0].name
        code = pizza.matches[0].code
        price_cents = pizza.matches[0].price_cents
      }
  ]
}

output "drinks" {
  value = [
    for drink in data.dominos_menu_item.drinks:
      {
        name = drink.matches[0].name
        code = drink.matches[0].code
        price_cents = drink.matches[0].price_cents
      }
  ]
}
