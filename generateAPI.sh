prefix="NDP"
suffix_service="Service"
suffix_api="Api"
list="
Auth
Cooperative
Demand
Evaluate
Logger
Message
Order
SplitPackage
System
User
"

# copy service dir to api dir
for item in $list
do
	service="$prefix$item$suffix_service"
	api="$prefix$item$suffix_api"
	echo "$service"
	cp -r "$service" "$api"
done
echo ""

# prepare api dir
for item in $list
do
	api="$prefix$item$suffix_api"
	echo "$api"
	cd $api
	rm -rf .git/
	rm -rf docker/
	rm -rf docker_dev/
	rm -rf src/test/
	rm -rf src/main/java/
	mkdir -p src/main/java/
	rm -rf src/main/proto/
	mkdir -p src/main/proto/
	rm -rf src/main/resources/
	mkdir -p src/main/resources/
	rm -rf target/
	rm *.iml
	cp ../pom_api.xml pom.xml
	cd ..
done
echo ""
