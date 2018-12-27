bool emailvalidate(String email){
  if(email.contains('@'))
    return true;
  return false;
}

bool passwordvalidate(String password){
  if(password.length>=6)
    return true;
  return false;
}

bool namevalidate(String name){
  if(name.length>0)
    return true;
  return false;
}