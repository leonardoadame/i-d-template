# Working Group Setup

Make a [new organization](https://github.com/organizations/new) for your working
group.  This guide will use the name `unicorn-wg` for your working group.

See the [more detailed guide](https://github.com/martinthomson/i-d-template/blob/master/doc/WG-SETUP.md).

# New Draft Setup

[Make a new repository](https://github.com/new).  This guide will use the
name `unicorn-protocol` in examples.

When prompted, select the option to initialize the repository with a README.

Clone that repository:
```sh
$ git clone https://github.com/unicorn-wg/unicorn-protocol.git
$ cd unicorn-protocol
```

Choose whether you want to use markdown, outline, or xml as your input form.
If you already have a draft, then that decision is already made for you.

Make a draft file.  The name of the file is important, make it match the name of
your draft.  You can take a copy of the
[example](https://github.com/martinthomson/i-d-template/blob/master/doc/example.md)
[files](https://github.com/martinthomson/i-d-template/blob/master/doc/example.xml)
if you are starting from scratch.

Edit the draft so that it has both a title and the correct name.  These tools
uses the `-latest` suffix in place of the usual number ('-00', or '-08').  The
number is generated automatically when you use `make submit`.

In XML, you should have at least:
```xml
<rfc docName="draft-ietf-unicorn-protocol-latest">
  <front>
    <title>The Unicorn Protocol</title>
```

Markdown is similar:
```yaml
docname: draft-ietf-unicorn-protocol-latest
title: The Unicorn Protocol
```

Commit and push your changes:
```sh
$ git commit -a
$ git push
```

Clone a copy of this respository into place:

```sh
$ git clone https://github.com/martinthomson/i-d-template lib
```

Option: If you prefer a stable version of this code, you can use `git submodule`
instead.

Run the setup command:

```sh
$ make -f lib/setup.mk
```

Option: If you prefer to use [Julian Reschke's
XSLT](https://github.com/reschke/xml2rfc) for generating HTML, add
`USE_XSLT=true` to the setup command line.

The setup removes adds some files, updates `README.md` with the details of
your draft, sets up a `gh-pages` branch for your editor's copy.  This pushes
the `gh-pages` branch to `origin`.  If you don't want that, run `make -f
lib/setup.mk setup-master` instead.

Finally, push:

```sh
$ git push
```


# Updating The Editor's Copy

Github will serve any HTML you check in on the `gh-pages` branch.  This can be
useful for ensuring that the latest version of your draft is available in a
usable form.

You can maintain `gh-pages` manually by running the following command
occasionally.

```sh
$ make ghpages
```

Or, you can setup an automatic commit hook using Travis or Circle CI.


# Automatic Update for Editor's Copy

Manual maintenance of `gh-pages` means that it will always be out of date.  You can
use an integrated continuous integration system to maintain a copy.

This requires that you sign in with [Circle](https://circleci.com/).
[Travis](https://travis-ci.org/) is also partially supported.

First [enable builds for the new repository](https://circleci.com/add-projects)
(or on [Travis](https://travis-ci.org/profile), though Travis might need to be
refreshed before you can see your repository).

Then, you need to get yourself a [new GitHub application
token](https://github.com/settings/tokens/new).  The application token only
needs the `public_repo` privilege.  This will let it push updates to your
`gh-pages` branch.

You can add environment variables using the Travis or Circle interface.  Include
a variable with the name `GH_TOKEN` and the value of your newly-created
application token.  On Travis, make sure to leave the value of "Display value in
build log" disabled, or you will be making your token public.

**WARNING**: You might want to use a dummy account for application tokens to
minimize the consequences of accidental leaks of your key.

Once you enable pushes, be very careful merging pull requests that alter
`circle.yml`, `.travis.yml`, or `Makefile`.  Those files can cause the value of
the token to be published for all to see.  You don't want that to happen.  Even
though tokens can be revoked easily, discovering a leak might take some time.
Only pushes to the main repository will be able to see the token, so don't worry
about pull requests.

Circle (or Travis) will now also check pull requests for errors, letting you
know if things didn't work out so that you don't merge anything suspect.
