## Read all github and gitlab profile readmes in one place (CLI).

[![License MIT](https://img.shields.io/npm/l/express.svg)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/jimmy-go/readm_stalker.svg?branch=master)](https://travis-ci.org/jimmy-go/readm_stalker)
[![Coverage Status](https://coveralls.io/repos/github/jimmy-go/readm_stalker/badge.svg?branch=master)](https://coveralls.io/github/jimmy-go/readm_stalker?branch=master)

![preview pic](https://github.com/jimmy-go/readme_stalker/blob/master/preview.jpg)

### Features:

* Fast overview about documentation quality.
* Easy following tasks for internal/public doc.

### Installation:

```
git clone git@github.com:jimmy-go/readme_stalker.git && cd readme_stalker
```

### Usage:

#### github.com

```
$ github.sh <USER> <BRANCH>
```

#### gitlab.com

```
$ gitlab.sh <USER> <BRANCH> <PERSONAL_TOKEN>
```

### Roadtrip:

- [x] Merge github public readmes in one file.
- [x] Merge gitlab public and privated readmes in one file.
- [x] Github Flavored Markdown.
- [ ] Gitlab Flavored Markdown.
- [ ] Testing.
- [ ] Read github private readmes.
- [ ] Add limit parameters for large profiles.
- [ ] Add custom parameters.

### Dependencies:

- [grip](https://github.com/joeyespo/grip)
