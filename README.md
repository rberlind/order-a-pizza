# Order a Pizza from Dominos using Terraform Cloud
This Terraform code can be linked to a Terraform Cloud workspace, enabling pizzas to be ordered via Terraform Cloud after you set variables with information for yourself, your credit card, and the store you want to order from.

This uses the [terraform-provider-dominos](https://github.com/ndmckinley/terraform-provider-dominos) provider by Nathan McKinley.

It uses Terraform 0.12 and allows you to order multiple pizzas and multiple drinks.

## Variables
Here are some of the key variables:
* *pizza_attributes* is a list of lists of words from the names of Dominos specialty pizzas as they appear on their website after selecting a style like "Deluxe", a size ("Small", "Medium", or "Large"), and a crust ("Hand Tossed", "Thin", or "Brooklyn").  So, you could set this to something like:
```
[
 ["Small", "Hand Tossed", "MeatZZa" ],
 ["Large", "Thin Crust", "Honolulu Hawaiian"]
]
```
* *drink_attributes* is a list of lists of words from the names of Dominos specialty pizzas as they appear on their website after selecting a type like "Coke" or "Diet Coke" and a size like "2-Liter Bottle" or "20oz Bottle".  So, you could set this to something like:
```
[
 ["20oz", "Coke"],
 ["20oz", "Diet Coke"]
]
```
* The *store_street*, *store_city*, *store_state*, and *store_zip_code* attributes are required to uniquely specify a store since the Dominos provider determines the store ID from these attributes.

The attributes *first_name*, *last_name*, *email*, and *phone* are needed in order to do a plan against the provider and run the Sentinel policy checks, but their values don't matter unless you actually do an apply which will actually order a pizza.  Please do not do an apply with a real credit card number since it will be charged and since Dominos will try to deliver a pizza to the address you gave.

## Sentinel Policies
There are 3 Sentinel policies that can be used to restrict orders placed with the provider:
1. [restrict-order-size.sentinel](./sentinel/restrict-order-size.sentinel) prevents an order from having more than 2 items in it.
1. [restrict-order-cost.sentinel](./sentinel/restrict-order-cost.sentinel) restricts orders from costing $21 or more.
1. [no-pineapple.sentinel](./sentinel/no-pineapple.sentinel) blocks pizzas that have pineapple on them by blocking any pizza that has "Hawaiian" in its name.
