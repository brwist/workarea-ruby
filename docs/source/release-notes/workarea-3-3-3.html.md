---
title: Workarea 3.3.3
excerpt:  Use config.action_mailer.show_previews to determine whether to cycle through all mailer previews provided by the platform and load them into the environment. This setting has the default value !Rails.env.production?, meaning it will be true as long a
---

# Workarea 3.3.3

## Load Mailer Previews in All Environments Except Production

Use `config.action_mailer.show_previews` to determine whether to cycle through all mailer previews provided by the platform and load them into the environment. This setting has the default value `!Rails.env.production?`, meaning it will be true as long as we're not in the production environment. This change also removes some "over-configuration" in core's **config/routes.rb** , as we were [replicating the routes that Rails already gives us out-of-box](https://github.com/rails/rails/blob/b9e0b4f19940fdd7105db3dffc507cbd89ac3705/actionmailer/lib/action_mailer/railtie.rb#L70-L74).

### Issues

- [ECOMMERCE-6128](https://jira.tools.weblinc.com/browse/ECOMMERCE-6128)

### Pull Requests

- [3450](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3450/overview)

### Commits

- [173eaeba4288c701bd563dc11419baa321f98c8c](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/173eaeba4288c701bd563dc11419baa321f98c8c)

## Fix Aria-label Text in Region Select

The original `aria-label` value for this element was the i18n text at **workarea.storefront.addresses.country**. It's changed to the correct key **workarea.storefront.addresses.region** , so that screen readers and other accessbility devices can know what the element is.

### Issues

- [ECOMMERCE-6148](https://jira.tools.weblinc.com/browse/ECOMMERCE-6148)

### Pull Requests

- [3464](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3464/overview)

### Commits

- [9e74f22203588576b5934fe45e25689fcf1ce47b](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/9e74f22203588576b5934fe45e25689fcf1ce47b)
- [14aacfa2d78a96da0c41e0f3bc1ba0b52a84c1bb](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/14aacfa2d78a96da0c41e0f3bc1ba0b52a84c1bb)

## Automatically Configure Dragonfly With Blank Region

We were automatically configuring Dragonfly to use S3 if one specified the `:region` field in the configuration. This caused an issue when attempting to set that field using the `$WORKAREA_S3_REGION` environment variable. We are now checking for the `:bucket_name` to be available in configuration somewhere, since that differs on a per-project basis, in order to apply this configuration. This should allow setting any of the `$WORKAREA_S3_*` environment variables used by Kubernetes to configure the app containers.

### Issues

- [ECOMMERCE-6146](https://jira.tools.weblinc.com/browse/ECOMMERCE-6146)

### Pull Requests

- [3459](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3459/overview)

### Commits

- [069d0cb3a8c07c259be92f5eadc070bcd22ec9f2](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/069d0cb3a8c07c259be92f5eadc070bcd22ec9f2)

## Check For Positive Sellable Count Before Using It to Determine Inventory Availability

When upgrading applications to v3.3.0, the `Inventory::Sku#sellable` field is typically unset in the DB, causing inventory capture to fail. We altered the logic of `Inventory::Capture` to consider the sellable field if the attribute is actually set in the database, otherwise, it will behave as it did in v3.2 and below.

### Issues

- [ECOMMERCE-6127](https://jira.tools.weblinc.com/browse/ECOMMERCE-6127)

### Pull Requests

- [3453](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3453)

### Commits

- [3d3d91c222c9fbc60e5a30be0baccd945724dd07](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/3d3d91c222c9fbc60e5a30be0baccd945724dd07)

## Add Dragonfly-s3\_datastore As a Dependency

We have default configuration that relies on the `dragonfly-s3_datastore` gem's availability in certain environments, so adding this as a dependency of the platform ensures version compatability and testability for the future.

### Issues

- [ECOMMERCE-6142](https://jira.tools.weblinc.com/browse/ECOMMERCE-6142)

### Pull Requests

- ??????&nbsp;

### Commits

- [ceb2a420e5030d09fa2b7bbd21743636b7e26237](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/ceb2a420e5030d09fa2b7bbd21743636b7e26237)

## Omit Current Sku From Product Cache Key When Not Selected

Originally, we defaulted the value of `Storefront::ProductViewModel#current_sku` to that of the first SKU in the product's list of variants. This was not accurately representing the state in which there was no selection made, thus causing problems with the template showing incorrect prices with caching enabled. We're now omitting this data point from the cache key if no SKU selection was made, which prevents overwriting the cache entries with incorrect data.

### Issues

- [ECOMMERCE-6145](https://jira.tools.weblinc.com/browse/ECOMMERCE-6145)

### Pull Requests

- [3463](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3463)

### Commits

- [ead2c5959da60cfc2f7ed67dad274f12ac515a01](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/ead2c5959da60cfc2f7ed67dad274f12ac515a01)

## Use Elasticsearch Client to Determine Health of Cluster

In deployed environments, we use [Easymon][] to determine the health of the application and its dependent services, such as Elasticsearch and MongoDB. For Elasticsearch, we're now using the client's transport to query the server for availability and general health, rather than making a raw JSON HTTP call to the server's endpoint.

### Issues

- [ECOMMERCE-6124](https://jira.tools.weblinc.com/browse/ECOMMERCE-6124)

### Pull Requests

- [3451](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3451/overview)

### Commits

- [f24c90df9a429f586c126abea65eaceb0d0a1eeb](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/f24c90df9a429f586c126abea65eaceb0d0a1eeb)

## Remove Memoization of User.console

The console user was typically found and memoized at `Workarea::User.console`, but in a multi-site environment that record may be different depending on the site database. We've removed this memoization from the method, and `User.console` will now query the DB every time it's called.

### Issues

- [ECOMMERCE-6140](https://jira.tools.weblinc.com/browse/ECOMMERCE-6140)

### Pull Requests

- [3454](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3454/overview)

### Commits

- [0ccd48e20de708f6c464ff36dbbe53289c83511f](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/0ccd48e20de708f6c464ff36dbbe53289c83511f)

## Hide Non-purchasable Products In Recommendations

If a product is not purchasable, we are no longer including it in product recommendations. This is so we don't recommend a product that a customer cannot put into their cart.

### Issues

- [ECOMMERCE-6135](https://jira.tools.weblinc.com/browse/ECOMMERCE-6135)

### Pull Requests

- [3452](https://stash.tools.weblinc.com/projects/WL/repos/workarea/pull-requests/3452/overview)

### Commits

- [df04327b434204730b41b11c7ee0a955810b41e9](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/df04327b434204730b41b11c7ee0a955810b41e9)
- [d368785247c08c5f8a7d07c0a3ac327a9bcfc153](https://stash.tools.weblinc.com/projects/WL/repos/workarea/commits/d368785247c08c5f8a7d07c0a3ac327a9bcfc153)

