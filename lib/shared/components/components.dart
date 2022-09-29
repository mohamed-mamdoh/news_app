import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news_app/modules/web_view/web_view_screen.dart';


  Widget buildArticleItem(article,context)=>InkWell(
    onTap: (){
      navigateTo(context,WebViewScreen(article['url']));
    },
    child: Padding(
     padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0,),
            image:  DecorationImage(
            image:  NetworkImage(
             '${article['urlToImage']}',

           ),
            fit: BoxFit.cover,
         ),
         ),
          ),
            const SizedBox(width: 20.0,),
            Expanded(
                  child: Container(
                  height: 120.0,
                      child: Column(

                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children:  [
                         Expanded(

                            child: Text(
                          ' ${article['title']}',
                           style: Theme.of(context).textTheme.bodyText1,
                           maxLines: 3,
                           overflow: TextOverflow.ellipsis,
                              ),
                          ),
                          Text(
                          '${article['publishedAt']}',
                           style: const TextStyle(
                           color: Colors.grey,

                       ),
                        ),

                       ],
                        ),
                        ),
                          ),
                            ],
                              ),
                                  ),
  );

  Widget myDivider()=>Padding(
    padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
   child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
   );
  Widget articleBuilder(list,context)=>ConditionalBuilder(

    condition:list.isNotEmpty,
    builder: (context)=>ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context,index)=>buildArticleItem(list[index],context),
      separatorBuilder: (context,index)=>myDivider(),
      itemCount: 15,
    ),
    fallback: (context)=>const Center(child: CircularProgressIndicator()),

  );

TextFormField defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  required Function? validate,
  required String label,
  required IconData prefix,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      validator: (s) {
        var res = validate!(s);
        return res;
      },
      keyboardType: type,
      onChanged: (s) => onChanged?.call(s),
      onFieldSubmitted: (s) => onSubmit?.call(s),
      onTap: () => onTap?.call(),
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
      ),
    );
void navigateTo(context,widget)=>Navigator.push(
    context,
    MaterialPageRoute(
      builder:(context)=>widget,
)
);