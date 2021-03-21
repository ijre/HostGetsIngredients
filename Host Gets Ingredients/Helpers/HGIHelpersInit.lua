local HelpersInit = function(file)
  dofile(string.format("%sHelpers/%s.lua", ModPath, file))
end

HelpersInit("HGIExcerpts")
HelpersInit("HGIPlayerManager")