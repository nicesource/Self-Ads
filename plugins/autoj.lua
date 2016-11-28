do

local function parsed_url(link)
  local parsed_link = URL.parse(link)
  local parsed_path = URL.parse_path(parsed_link.path)
  return parsed_path[2]
end

function run(msg, matches)
if redis:get("id:"..msg.to.id..":"..msg.from.id) then
return "هر یک دقیقه یک بار"
end
  redis:setex("id:"..msg.to.id..":"..msg.from.id, 60, true)


  local hash = parsed_url(matches[1])   

  join = import_chat_link(hash,ok_cb,false)
  return reply_msg(msg.id,'',ok_cb,false)
end

return {
  patterns = {
    "([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)",
  }, 
  run = run
}

end
