using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ColorMate.EF.Migrations
{
    /// <inheritdoc />
    public partial class AddSuggestionsFile : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Recommendation",
                table: "OutfitRatingsWithImages");

            migrationBuilder.CreateTable(
                name: "OutfitSuggestions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Rank = table.Column<int>(type: "int", nullable: false),
                    Text = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Urgency = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OutfitRatingWithImageId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OutfitSuggestions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OutfitSuggestions_OutfitRatingsWithImages_OutfitRatingWithImageId",
                        column: x => x.OutfitRatingWithImageId,
                        principalTable: "OutfitRatingsWithImages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_OutfitSuggestions_OutfitRatingWithImageId",
                table: "OutfitSuggestions",
                column: "OutfitRatingWithImageId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OutfitSuggestions");

            migrationBuilder.AddColumn<string>(
                name: "Recommendation",
                table: "OutfitRatingsWithImages",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
