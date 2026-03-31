{
    # Function get the verions of a downloaded rsc script file
    # $getVerion fileContent="Content of the file"
        :Local getVersion do={
        :local version 999999999999
        :if ([:len $fileContent] > 0) do={
            :set $version [:pick $fileContent 11 23]
        }
        :return $version
    }
}