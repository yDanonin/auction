const { getPrismaClient } = require('../datasource/prisma-datasource')
const prismaClient = getPrismaClient()

const main = async () => {
  console.log('ta entrando aqui')
  await prismaClient.test.create({
    data: {
      text: 'aaaaaaaaaaaa'
    }
  })
  console.log('ta passando aqui')
  await prismaClient.test.findFirst().then(result => console.log('RESULTADO MEU MANO: ', result))
}

main()
  .then(() => console.log('ok'))
  .catch((e) => {
    console.error(e)
    throw e
  })
  .finally(async () => {
    await prismaClient.$disconnect()
    process.exit(0)
  })