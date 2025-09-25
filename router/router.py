from fastapi import APIRouter
from service.service import User
from service.service import Portfolio

router = APIRouter()

@router.get("/users")
def get_users():
    return [{"id": 1, "name": "John Doe"}]

@router.get("/user")
def get_user(id: int):
    user = User.fetch_by_id(id)
    if user:
        return {
            "id": user["id"],
            "name": user["name"],
            "age": user["age"],
            "gender": user["gender"]
        }
    return {"error": "User not found"}

@router.get("/portfolio")
def get_portfolio(id: int):
    portfolio = Portfolio.fetch_by_portfolio_id(id)
    if portfolio:
        return {
            "total_money": portfolio["total_money"],
            "invested": portfolio["invested"],
            "isa_life_time": portfolio["isa_life_time"],
            "pension": portfolio["pension"],
            "cash_isa": portfolio["cash_isa"],
            "stocks": portfolio["stocks"],
            "GIA": portfolio["GIA"],
            "balance": portfolio["balance"]
        }
    return {"error": "Portfolio not found for user"}
