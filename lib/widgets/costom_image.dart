import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
CachedNetworkImage mm(mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) =>
        const Padding(padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
    errorWidget: (context, url, error) => const Icon(Icons.error),

  );
}