const Review = require("../model/Reviewmodel");

module.exports.createReview = async (req, res) => {
  try {
    const { paperId, userId, rating, comment } = req.body;
    const review = new Review({ paperId, userId, rating, comment });
    await review.save();
    res.status(201).json(review);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

module.exports.getAllReviews = async (req, res) => {
  try {
    const reviews = await Review.find().populate("paperId").populate("userId");
    res.json(reviews);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports.getReviewById = async (req, res) => {
  try {
    const { ReviewId } = req.params;
    const review = await Review.findById(ReviewId)
      .populate("paperId")
      .populate("userId");
    if (!review) return res.status(404).json({ error: "Review not found" });
    res.json(review);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports.updateReview = async (req, res) => {
  try {
    const { rating, comment } = req.body;
    const { ReviewId } = req.params;
    const review = await Review.findByIdAndUpdate(
      ReviewId,
      { rating, comment, updatedAt: Date.now() },
      { new: true, runValidators: true }
    );
    if (!review) return res.status(404).json({ error: "Review not found" });
    res.json(review);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

module.exports.deleteReview = async (req, res) => {
  try {
    const { ReviewId } = req.params;
    const review = await Review.findByIdAndDelete(ReviewId);
    if (!review) return res.status(404).json({ error: "Review not found" });
    res.json({ message: "Review deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports.calculatereview = async (req, res) => {
  try {
    const { paperId } = req.params;

    const result = await Review.aggregate([
      { $match: { paperId: mongoose.Types.ObjectId(paperId) } },
      {
        $group: {
          _id: "$paperId",
          averageRating: { $avg: "$rating" },
          reviewCount: { $sum: 1 },
        },
      },
    ]);

    if (result.length === 0) {
      return res
        .status(404)
        .json({ message: "No reviews found for this paper" });
    }

    res.json({
      paperId,
      averageRating: result[0].averageRating.toFixed(2),
      reviewCount: result[0].reviewCount,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
