terraform {
  required_version = ">= 1.3.0"

  required_providers {
    http-full = {
      source  = "salrashid123/http-full"
      version = ">= 1.3.1"
    }
    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}