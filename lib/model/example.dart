
/*
StreamBuilder<String>(
stream: _loadBackgroundImage(),
builder: (context,snapshot){
switch (snapshot.connectionState){
case ConnectionState.waiting:
return CircularProgressIndicator();
case ConnectionState.done:
return Container(
decoration:  BoxDecoration(
image: DecorationImage(
image: NetworkImage(snapshot.data!),
fit: BoxFit.cover
)
),

child: Column(
children: [
Expanded(
child: StreamBuilder(
stream: productStream,
builder: (context, snapshot) {
switch (snapshot.connectionState) {
case ConnectionState.waiting:
return Center(
child: CircularProgressIndicator(),
);
case ConnectionState.active:
if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
} else {
List<Product> productList = snapshot.data!;
return ListView.separated(
itemCount: productList.length,
itemBuilder: (BuildContext context, int index) {
return ListTile(
leading:
Text(productList[index].name.toString()),
trailing: GestureDetector(
child: Icon(productList[index].isBuy
? Icons.shopping_basket
    : Icons.shopping_basket_outlined),
onTap: () {
changeProduct(productList[index]);
},
));
},
separatorBuilder: (BuildContext context, int index) {
return Divider(
height: 10,
color: Colors.blue,
);
},
);
}
break;
default:
return Container();
}
},
)),
Padding(
padding: EdgeInsets.all(8),
child: Row(
children: [
Expanded(
child: SizedBox(
height: 40,
child: TextField(
controller: productController,
decoration: InputDecoration(
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(
width: 1,
color: Colors.blue), //<-- SEE HERE
),
hintText: 'Введите товар',
)),
),
),
SizedBox(
width: 10,
),
DropdownButton<String>(
value: selectedItem,
items: items
    .map((item) =>
DropdownMenuItem(value: item, child: Text(item)))
    .toList(),
onChanged: (String? oldValue) {
setState(() {
selectedItem = oldValue!;
});
},
),
SizedBox(
width: 10,
),
ElevatedButton(
child: Text('Добавить'),
onPressed: () {
addProduct();
},
)
],
),
)
],
),
);
default:return Container();
}
},
)

*/