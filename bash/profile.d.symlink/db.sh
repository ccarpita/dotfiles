#!/usr/bin/env bash

function pg-relation-size () {
  psql -t -c "select pg_size_pretty(pg_relation_size((SELECT oid FROM pg_class WHERE relname = '$1')))"
}
