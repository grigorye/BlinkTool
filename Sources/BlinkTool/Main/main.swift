import BlinkOpenAPI
import Foundation
import GETracing

traceEnabledEnforced = true
sourceLabelsEnabledEnforced = true
dumpInTraceEnabledEnforced = true

x$(BlinkOpenAPIAPI.basePath)
BlinkTool.main()
