acmeshow(){
if [ -n "$(/root/.acme.sh/acme.sh -v 2>/dev/null)" ]; then
  caacme1=$(/root/.acme.sh/acme.sh --list | tail -1 | awk '{print $1}')
  if [ -n "$caacme1" ]; then
    caacme=$caacme1
  else
    caacme='无证书申请记录'
  fi
else
  caacme='未安装acme'
fi
}

acmeshow
echo "$caacme"
