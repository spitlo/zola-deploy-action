# Zola Deploy Action

A GitHub action to manually build a [zola](https://github.com/getzola/zola) site to the `docs` folder in the repository to be used for GitHub Pages.

## Table of Contents

 - [Usage](#usage)
 - [Environment variables](#environment-variables)
 - [Custom Domain](#custom-domain)

## Usage

In `.github/workflows` you can put any `.yml` file and put the following contents inside.

```
name: Deploy site

on:
  workflow_dispatch

jobs:
  build:
    name: spitlo/zola-deploy-action
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: spitlo/zola-deploy-action
      uses: spitlo/zola-deploy-action@master
      env:
        TOKEN: ${{ secrets.TOKEN }}
```

You can the trigger the workflow from the Actions tab in your repository.

## Environment Variables

 * `TOKEN`: [Personal Access key](https://github.com/settings/tokens) with the scope `public_repo`, we need this
    to push the site files back to the repo.

## Custom Domain

If you're using a custom domain for your GitHub Pages site put the CNAME 
in `static/CNAME` so that zola puts it in the root of the public folder
which is where GitHub expects it to be.
