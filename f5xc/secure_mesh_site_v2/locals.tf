locals {
  algorithm = jsondecode(base64decode(split(".", split("content:", split("map[", split(" ", restapi_object.token.api_data.spec)[0])[1])[1])[0]))
  api_response = jsondecode(restapi_object.token.api_response)
  performance_enhancement_mode = [
    { f5xc_sms_perf_mode_l7_enhanced = {} }, {
      perf_mode_l3_enhanced = {
        jumbo = {}
      }
    }
  ][var.f5xc_sms_perf_mode_l7_enhanced ? 0 : 1]
}