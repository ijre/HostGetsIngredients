local HelpersInit = function(file)
  dofile(string.format("%sHelpers/%s.lua", HGI.Path, file))
end

HelpersInit("HGIExcerpts")
HelpersInit("HGIPlayerManager")
HelpersInit("HGIUtils")