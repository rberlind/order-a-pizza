# Order a Pizza from Dominos using Terraform Cloud
This Terraform code can be linked to a Terraform Cloud workspace, enabling pizzas to be ordered via Terraform Cloud after you set variables with information for yourself, your credit card, and the store you want to order from.

This uses the [terraform-provider-dominos](https://github.com/ndmckinley/terraform-provider-dominos) provider by Nathan McKinley.

## Sentinel Policies
There are 3 Sentinel policies that can be used to restrict orders placed with the provider:
1. [restrict-order-size.sentinel](./sentinel/restrict-order-size.sentinel) prevents an order from having more than 2 items in it.
1. [restrict-order-cost.sentinel](./sentinel/restrict-order-cost.sentinel) restricts orders from costing $21 or more.
1. [no-pineapple.sentinel](./sentinel/no-pineapple.sentinel) blocks pizzas that have pineapple on them by blocking any pizza that has "Hawaiian" in its name.
