# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-getHeaderValue.rsc
# Stored Script Name: MMS-getHeaderValue
# Description: Gets a header value from a script file or stored script header by marker.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Get a header value from the header of a script file (.rsc) or stored script.
    # example: :set $scriptName [$getHeaderValue $cont "# Script Name:"]
    :global getHeaderValue do={
        :local value ""
        :local fileContent [:tostr $1]
        :local searchMarker [:tostr $2]

        :if ([:len $fileContent] > 0 and [:len $searchMarker] > 0) do={
            :local markerPos [:find $fileContent $searchMarker]
            :if ([:typeof $markerPos] != "nil") do={
                :local valueStart ($markerPos + [:len $searchMarker])
                :local lineEnd [:find $fileContent "\n" $valueStart]
                :if ([:typeof $lineEnd] = "nil") do={
                    :set lineEnd [:len $fileContent]
                }

                :local rawValue [:pick $fileContent $valueStart $lineEnd]
                :local left 0
                :local right [:len $rawValue]

                :while ($left < $right) do={
                    :local ch [:pick $rawValue $left ($left + 1)]
                    :if ($ch = " ") do={
                        :set left ($left + 1)
                    } else={
                        :set left ($left + 1000000)
                    }
                }
                :if ($left > 1000000) do={
                    :set left ($left - 1000000)
                }

                :while ($right > $left) do={
                    :local ch [:pick $rawValue ($right - 1) $right]
                    :if ($ch = " ") do={
                        :set right ($right - 1)
                    } else={
                        :set right ($right + 1000000)
                    }
                }
                :if ($right > 1000000) do={
                    :set right ($right - 1000000)
                }

                :if ($left < $right) do={
                    :set value [:pick $rawValue $left $right]
                }
            }
        }

        :return $value
    }
}
