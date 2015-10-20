# lita-estimate

[![Gem Version](https://badge.fury.io/rb/lita-estimate.svg)](https://badge.fury.io/rb/lita-estimate)
[![Build Status](https://travis-ci.org/ingoweiss/lita-estimate.png?branch=master)](https://travis-ci.org/ingoweiss/lita-estimate)
[![Coverage Status](https://coveralls.io/repos/ingoweiss/lita-estimate/badge.png)](https://coveralls.io/r/ingoweiss/lita-estimate)
[![Code Climate](https://codeclimate.com/github/ingoweiss/lita-estimate/badges/gpa.svg)](https://codeclimate.com/github/ingoweiss/lita-estimate)

Just a silly little Lita plugin for estimation

## Installation

Add lita-estimate to your Lita instance's Gemfile:

``` ruby
gem "lita-estimate"
```

## Usage

```
1) In private chats with the bot:

Peter> @bot estimate US123 as 5
Bot> Thanks!

Paula> @bot estimate US123 as 3
Bot> Thanks!

2) In team room:

Carl> @bot US123 estimates
Bot> 5 (Peter)
Bot> 3 (Paula)
Bot> 4.0 (Average)

3) For more:

Carl> @bot help
```
