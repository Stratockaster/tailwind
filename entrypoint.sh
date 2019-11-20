#!/bin/bash
export $(cat .env | xargs) && /bin/bash