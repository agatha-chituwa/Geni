import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geni_app/model/faq_model.dart';
import '../repositories/faq_repository.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamProvider<List<FAQ>>.value(
        value: FAQRepository().getFAQs(),
        initialData: const [],
        builder: (context, child) {
          final faqs = Provider.of<List<FAQ>>(context);
          return faqs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  leading: const Icon(
                    Icons.question_answer,
                    size: 40,
                    color: Color(0xFF19CA79),
                  ),
                  title: Text(
                    faq.question,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FAQDetailPage(faq: faq)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FAQDetailPage extends StatelessWidget {
  final FAQ faq;

  const FAQDetailPage({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ Details'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                faq.question,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                faq.answer,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
