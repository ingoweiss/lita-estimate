# lita-estimate

[![Build Status](https://travis-ci.org/ingoweiss/lita-estimate.png?branch=master)](https://travis-ci.org/ingoweiss/lita-estimate)
[![Coverage Status](https://coveralls.io/repos/ingoweiss/lita-estimate/badge.png)](https://coveralls.io/r/ingoweiss/lita-estimate)

Just a silly little Lita plugin for estimation

## Installation

Add lita-estimate to your Lita instance's Gemfile:

``` ruby
gem "lita-estimate"
```

## Usage

```
1) in private chats with the bot:

Peter> @bot estimate US123 as 5
Bot> Thanks!

Paula> @bot estimate US123 as 3
Bot> Thanks!

2) in team room:

Carl> @bot estimates
Bot> Peter: 5
Bot> Paula: 3
Bot> Average: 4
```