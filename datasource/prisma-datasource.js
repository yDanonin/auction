const { PrismaClient } = require('@prisma/client')

const dbClient = new PrismaClient({
  errorFormat: process.env.PRISMA_ERROR_FORMAT || 'minimal',
})

const getPrismaClient = () => {
  return dbClient
}

module.exports = {
  getPrismaClient
}

