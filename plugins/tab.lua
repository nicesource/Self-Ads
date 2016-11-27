local add_user_cfg = load_from_file('data/add_user_cfg.lua')

local function template_add_user(base, to_username, from_username, chat_name, chat_id)
   base = base or ''
   to_username = '@' .. (to_username or '')
   from_username = '@' .. (from_username or '')
   chat_name = string.gsub(chat_name, '_', ' ') or ''
   chat_id = "chat#id" .. (chat_id or '')
   if to_username == "@" then
      to_username = ''
   end
   if from_username == "@" then
      from_username = ''
   end
   base = string.gsub(base, "{to_username}", to_username)
   base = string.gsub(base, "{from_username}", from_username)
   base = string.gsub(base, "{chat_name}", chat_name)
   base = string.gsub(base, "{chat_id}", chat_id)
   return base
end

function chat_new_user_link(msg)
   local pattern = add_user_cfg.initial_chat_msg
   local to_username = msg.from.username
   local from_username = 'link (@' .. (msg.action.link_issuer.username or '') .. ')'
   local chat_name = msg.to.print_name
   local chat_id = msg.to.id
   pattern = template_add_user(pattern, to_username, from_username, chat_name, chat_id)
   if pattern ~= '' then
      local receiver = get_receiver(msg)
      send_msg(receiver, pattern, ok_cb, false)
   end
end

function chat_new_user(msg)
   local pattern = add_user_cfg.initial_chat_msg
   local to_username = msg.action.user.username
   local from_username = msg.from.username
   local chat_name = msg.to.print_name
   local chat_id = msg.to.id
   pattern = template_add_user(pattern, to_username, from_username, chat_name, chat_id)
   if pattern ~= '' then
      local receiver = get_receiver(msg)
      send_msg(receiver, pattern, ok_cb, false)
   end
end

local function description_rules(msg, nama)
   local data = load_data(_config.moderation.data)
   if data[tostring(msg.to.id)] then
      local about = ""
      local rules = ""
      if data[tostring(msg.to.id)]["description"] then
         about = data[tostring(msg.to.id)]["description"]
         about = "\nAbout :\n"..about.."\n"
      end
      if data[tostring(msg.to.id)]["rules"] then
         rules = data[tostring(msg.to.id)]["rules"]
         rules = "\nRules :\n"..rules.."\n"
      end
      local sambutan = "hi "..nama.." welcome to ["..string.gsub(msg.to.print_name, "_", " ").."]"
      local text = sambutan..about..rules.."\n"
      local receiver = get_receiver(msg)
      send_large_msg(receiver, text, ok_cb, false)
   end
end

local function run(msg, matches)
   if not msg.service then
      return "Are you trying to troll me?"
   end
   --vardump(msg)
   if matches[1] == "channel_add_user_link" then
      return "ربات ضد لینک چیست ؟ \n-رباتی ک میتونین با اون گروهتون رو از \n+اسپم \n+لینک فرستادن کاربران\n+ چالش \n+کلمات بد\nو ...\nمحافظت کنین\n😍😍 با کلی امکانات دیگه\n—------------------------\nاگه این رباتو میخاید بیاید گروه زیر سفارش بدید\nhttps://telegram.me/joinchat/DHi5Sz6vOIwg850BW3TuDA\n\n*فقط 3 هزار تومن برای این ربات پیشرفته\n*گروهتون رو برای همیشه با امنیت کنید\n*اگه به هر دلیلی توانایی پرداخت هزینه ربات رو ندارید ، میتونید 2 نفر خریدار به ما معرفی کنید"
   elseif matches[1] == "chat_add_user_link" then
      return "ربات ضد لینک چیست ؟ \n-رباتی ک میتونین با اون گروهتون رو از \n+اسپم \n+لینک فرستادن کاربران\n+ چالش \n+کلمات بد\nو ...\nمحافظت کنین\n😍😍 با کلی امکانات دیگه\n—------------------------\nاگه این رباتو میخاید بیاید گروه زیر سفارش بدید\nhttps://telegram.me/joinchat/DHi5Sz6vOIwg850BW3TuDA\n\n*فقط 3 هزار تومن برای این ربات پیشرفته\n*گروهتون رو برای همیشه با امنیت کنید\n*اگه به هر دلیلی توانایی پرداخت هزینه ربات رو ندارید ، میتونید 2 نفر خریدار به ما معرفی کنید"
   elseif matches[1] == " " then
       local bye_name = "@"..msg.action.user.username
       return 
   end
end

return {
   description = "Welcoming Message",
   usage = "send message to new member",
   patterns = {
      "^!!tgservice (chat_add_user_link)$",
             "^!!tgservice (channel_add_user_link)$"
   },
   run = run
}
