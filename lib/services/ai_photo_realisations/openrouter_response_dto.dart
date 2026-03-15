class OpenRouterResponseDto {
  final String id;
  final String object;
  final int created;
  final String model;
  final String provider;
  final dynamic systemFingerprint;
  final List<Choice> choices;
  final Usage usage;

  OpenRouterResponseDto({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.provider,
    this.systemFingerprint,
    required this.choices,
    required this.usage,
  });

  factory OpenRouterResponseDto.fromJson(Map<String, dynamic> json) {
    return OpenRouterResponseDto(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      provider: json['provider'],
      systemFingerprint: json['system_fingerprint'],
      choices: (json['choices'] as List).map((choice) => Choice.fromJson(choice)).toList(),
      usage: Usage.fromJson(json['usage']),
    );
  }
}

class Choice {
  final int index;
  final dynamic logprobs;
  final String finishReason;
  final String nativeFinishReason;
  final Message message;

  Choice({
    required this.index,
    this.logprobs,
    required this.finishReason,
    required this.nativeFinishReason,
    required this.message,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
      nativeFinishReason: json['native_finish_reason'],
      message: Message.fromJson(json['message']),
    );
  }
}

class Message {
  final String role;
  final String content;
  final dynamic refusal;
  final dynamic reasoning;
  final List<dynamic> reasoningDetails;
  final List<ImageData> images;

  Message({
    required this.role,
    required this.content,
    this.refusal,
    this.reasoning,
    required this.reasoningDetails,
    required this.images,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'] ?? '',
      refusal: json['refusal'],
      reasoning: json['reasoning'],
      reasoningDetails: json['reasoning_details'] ?? [],
      images: (json['images'] as List?)
              ?.map((image) => ImageData.fromJson(image))
              .toList() ?? [],
    );
  }
}

class ImageData {
  final String type;
  final ImageUrl imageUrl;

  ImageData({
    required this.type,
    required this.imageUrl,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      type: json['type'],
      imageUrl: ImageUrl.fromJson(json['image_url']),
    );
  }
}

class ImageUrl {
  final String url;

  ImageUrl({required this.url});

  factory ImageUrl.fromJson(Map<String, dynamic> json) {
    return ImageUrl(
      url: json['url'],
    );
  }
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final double cost;
  final bool isByok;
  final PromptTokensDetails promptTokensDetails;
  final CostDetails costDetails;
  final CompletionTokensDetails completionTokensDetails;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    required this.cost,
    required this.isByok,
    required this.promptTokensDetails,
    required this.costDetails,
    required this.completionTokensDetails,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
      cost: json['cost'].toDouble(),
      isByok: json['is_byok'],
      promptTokensDetails: PromptTokensDetails.fromJson(json['prompt_tokens_details']),
      costDetails: CostDetails.fromJson(json['cost_details']),
      completionTokensDetails: CompletionTokensDetails.fromJson(json['completion_tokens_details']),
    );
  }
}

class PromptTokensDetails {
  final int cachedTokens;
  final int cacheWriteTokens;
  final int audioTokens;
  final int videoTokens;

  PromptTokensDetails({
    required this.cachedTokens,
    required this.cacheWriteTokens,
    required this.audioTokens,
    required this.videoTokens,
  });

  factory PromptTokensDetails.fromJson(Map<String, dynamic> json) {
    return PromptTokensDetails(
      cachedTokens: json['cached_tokens'] ?? 0,
      cacheWriteTokens: json['cache_write_tokens'] ?? 0,
      audioTokens: json['audio_tokens'] ?? 0,
      videoTokens: json['video_tokens'] ?? 0,
    );
  }
}

class CostDetails {
  final double upstreamInferenceCost;
  final double upstreamInferencePromptCost;
  final double upstreamInferenceCompletionsCost;

  CostDetails({
    required this.upstreamInferenceCost,
    required this.upstreamInferencePromptCost,
    required this.upstreamInferenceCompletionsCost,
  });

  factory CostDetails.fromJson(Map<String, dynamic> json) {
    return CostDetails(
      upstreamInferenceCost: json['upstream_inference_cost'].toDouble(),
      upstreamInferencePromptCost: json['upstream_inference_prompt_cost'].toDouble(),
      upstreamInferenceCompletionsCost: json['upstream_inference_completions_cost'].toDouble(),
    );
  }
}

class CompletionTokensDetails {
  final int reasoningTokens;
  final int imageTokens;
  final int audioTokens;

  CompletionTokensDetails({
    required this.reasoningTokens,
    required this.imageTokens,
    required this.audioTokens,
  });

  factory CompletionTokensDetails.fromJson(Map<String, dynamic> json) {
    return CompletionTokensDetails(
      reasoningTokens: json['reasoning_tokens'] ?? 0,
      imageTokens: json['image_tokens'] ?? 0,
      audioTokens: json['audio_tokens'] ?? 0,
    );
  }
}