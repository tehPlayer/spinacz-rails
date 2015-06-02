Spinacz Rails
===================

This is a Rails Gem for Spinacz API.

## Instalation

```console
gem install spinacz
```

or add it to your `Gemfile`:

```ruby
gem 'spinacz'
```

## Usage

Create instance of gem:

```ruby
spinacz = Spinacz::Client.new(email: 'your@email.here', password: 'P4ssw0rd_H3r3')
```

or

```ruby
spinacz = Spinacz::Client.new(token: 'authorization_token_from_login')
```

or, if you want to use only public methods without authorization:

```ruby
spinacz = Spinacz::Client.new
```

You can also use test mode API by adding attribute `test` to initializer:

```ruby
spinacz = Spinacz::Client.new(email: 'your@email.here', password: 'P4ssw0rd_H3r3', test: true)
```

After that, you can access Spinacz methods, for example:

```ruby
spinacz.login
# login method will set token to spinacz API automatically, to prevent multiple authorizations
spinacz.get_packages_templates 
# this will return whole response from API
```

Available methods (attributes as stated in Spinacz API documentation):

```ruby
    spinacz.login
    spinacz.add_package_DHL({...})
    spinacz.add_package_DPD({...})
    spinacz.add_package_FEDEX({...})
    spinacz.add_package_GLS({...})
    spinacz.add_package_INPOST({...})
    spinacz.add_package_KEX({...})
    spinacz.add_package_POCZTA({...})
    spinacz.add_package_UPS({...})
    spinacz.cancel({...})
    spinacz.get_packages_templates
    spinacz.get_paczkomaty({...})
    spinacz.get_placowki({...})
    spinacz.get_send_points
    spinacz.pickup({...})
```

## Contribution

If you want to contribute to the code, just create pull request, and I will merge it ASAP. 
Thank you for help.

## TODO

Add tests.
Add better interface for response.
Add validations.

## License

Copyright (c) 2015 Marcin Adamczyk, released under the MIT license


*Feel free to contact me if you need help: marcin.adamczyk [--a-t--] subcom.me*
